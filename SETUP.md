# Package Setup & Infrastructure

This document describes how this Julia package is wired up: the branch model,
documentation, test structure, every CI/automation workflow (with its full
contents and a short explanation), and the GitHub settings that have to be
configured in the web UI (they are **not** stored in the repository).

Use it as a reference for this repo, or as a blueprint when bootstrapping a new
Julia package.

---

## 1. Branch model

| Branch | Role |
| --- | --- |
| `dev` | Integration branch. All your own work goes here first. |
| `main` | Stable / release branch. Updated only by merging `dev → main`. Tagged releases are cut here. |

- **Your work:** commit to `dev`, then open a `dev → main` PR. Merge it with a
  **merge commit** (not squash) so the histories stay linked.
- **Bots (Dependabot, CompatHelper):** open their PRs against the default branch
  (`main`) and are auto-merged there.
- **Keeping `dev` current:** because bot updates land on `main`, periodically
  sync `main → dev` with a local **fast-forward** (no merge commit):
  ```bash
  git checkout dev
  git fetch origin
  git merge --ff-only origin/main
  git push origin dev
  ```
  (Syncing via a GitHub PR instead would create an empty merge commit and leave
  `dev` cosmetically "ahead".)

The docs `dev` version tracks the `dev` branch; the `stable` version tracks
git tags (see §3).

---

## 2. Documentation structure

Built with [Documenter.jl](https://documenter.juliadocs.org) and deployed to the
`gh-pages` branch, served at `https://JoshuaTetzner.github.io/ExaFMMt.jl/`.

```
docs/
├── Project.toml          # docs environment: Documenter, ExaFMMt, MKL
├── make.jl               # build + deploy configuration
└── src/
    ├── index.md                  # Introduction (landing page)
    ├── manual/
    │   ├── manual.md             # General Usage
    │   └── examples.md           # Application Examples
    ├── details/
    │   ├── fmm.md                # Fast Multipole Method (theory)
    │   └── bem.md                # FMM with the BEM
    ├── contributing.md           # Contributing guide
    └── apiref.md                 # API Reference (@autodocs)
```

Key points:

- **`apiref.md` uses `@autodocs`** (`Modules = [ExaFMMt]`, `Private = true`), so
  every docstring in the package is rendered automatically — nothing to maintain
  by hand, and the build fails if a docstring goes missing from the manual.
- **Examples are executable.** The code in `manual/manual.md` and
  `manual/examples.md` uses Documenter `@example` blocks (not plain ```` ```julia ````),
  so they are run at build time and the build **fails if the API drifts**.
  `MKL` is in `docs/Project.toml` so the FMM examples have a BLAS backend.
  (We use `@example`, not `jldoctest`, because the examples use `rand` and have
  no fixed output to assert.)
- **`.dat` cleanup.** Running the FMM examples makes exafmm-t write
  precomputation `*.dat` files into the build tree. `make.jl` deletes them from
  `docs/build` between `makedocs` and `deploydocs` so they are not deployed to
  `gh-pages`.
- **Deployment** is configured in `make.jl` via `deploydocs` with
  `devbranch="dev"`: pushing to `dev` redeploys the `dev` docs; pushing a git
  tag deploys a versioned `stable` build. (On PRs and on `main`, the build runs
  but deployment is skipped.)

---

## 3. Test structure

Run with `Pkg.test()`. Tests use
[TestItemRunner.jl](https://github.com/julia-vscode/TestItemRunner.jl)
(`@run_package_tests`). Beyond the package's numerical tests, several
**quality testitems** run as part of the suite:

| Test | Tool | What it checks |
| --- | --- | --- |
| `fmm` testset | — | The actual package: Laplace / Helmholtz / modified-Helmholtz FMM correctness. |
| Code quality | [Aqua.jl](https://github.com/JuliaTesting/Aqua.jl) | Method ambiguities, unbound type params, undefined exports, stale deps, compat bounds, piracy, persistent tasks. |
| Code formatting | [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) | All files match the style in `.JuliaFormatter.toml`. |
| Static analysis | [JET.jl](https://github.com/aviatesk/JET.jl) | Type errors / inference problems, scoped to `ExaFMMt` only (so the `ccall`/`Exafmmt_jll` FFI boundary isn't reported). |
| Explicit imports | [ExplicitImports.jl](https://github.com/ericphanson/ExplicitImports.jl) | No stale explicit imports, imports come from their owner, no self-qualified accesses. |

The quality tools live in the `test` target of `Project.toml` (`[extras]` +
`[targets]`), so they are only installed for testing, never as runtime deps.

`test/runtests.jl`:

```julia
using Test
using TestItems
using TestItemRunner
using ExaFMMt
using Random

Random.seed!(1234)

@testset "fmm" begin
    include("test_laplace.jl")
    include("test_helmholtz.jl")
    include("test_modifiedhelmholtz.jl")
end

@testitem "Code quality (Aqua.jl)" begin
    using Aqua
    using ExaFMMt
    Aqua.test_all(ExaFMMt)
end

@testitem "Code formatting (JuliaFormatter.jl)" begin
    using JuliaFormatter
    using ExaFMMt
    @test JuliaFormatter.format(pkgdir(ExaFMMt), overwrite=false)
end

@testitem "Static analysis (JET.jl)" begin
    using JET
    using ExaFMMt
    # Restrict analysis to ExaFMMt's own code so the ccall / Exafmmt_jll FFI
    # boundary and Base/stdlib internals are not reported.
    JET.test_package(ExaFMMt; target_modules=(ExaFMMt,))
end

@testitem "Explicit imports (ExplicitImports.jl)" begin
    using ExplicitImports
    using ExaFMMt
    @test ExplicitImports.check_no_stale_explicit_imports(ExaFMMt) === nothing
    @test ExplicitImports.check_all_explicit_imports_via_owners(ExaFMMt) === nothing
    @test ExplicitImports.check_no_self_qualified_accesses(ExaFMMt) === nothing
end

@run_package_tests verbose = true
```

> **Note:** `ExplicitImports.check_no_implicit_imports` is intentionally *not*
> enabled. The package uses `using LinearAlgebra` / `using LinearMaps` /
> `using Exafmmt_jll`; enabling that strict check would require converting every
> import to the explicit `using X: name` form.

Coverage is generated as `lcov.info` during the test run. It is a **generated
artifact** — gitignored and never committed — and is uploaded to Codecov by CI
(see §4.1 / §5.2).

---

## 4. Workflows

All under `.github/workflows/`. Each is shown in full followed by a short
explanation.

### 4.1 `CI.yml` — test suite

```yaml
name: CI
on:
  push:
    branches:
      - 'main'
      - 'dev'
    tags: '*'
  pull_request:
    branches:
      - 'main'
      - 'dev'
  release:
    types: [published]

jobs:
  test:
    name: Julia ${{ matrix.version }} - ${{ matrix.os }} - ${{ matrix.arch }}
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        version:
          - '1.10'
          - '1'
        os:
          - ubuntu-latest
        arch:
          - x64
    steps:
      - uses: actions/checkout@v7
      - uses: julia-actions/setup-julia@v3
        with:
          version: ${{ matrix.version }}
          arch: ${{ matrix.arch }}
      - uses: julia-actions/cache@v3
      - uses: julia-actions/julia-buildpkg@v1
      - uses: julia-actions/julia-runtest@v1
      - uses: julia-actions/julia-processcoverage@v1
      - uses: codecov/codecov-action@v7
        with:
          files: lcov.info
        env:
          CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
```

Runs `Pkg.test()` on pushes/PRs to `main` and `dev`, on tags, and on releases.
Tests the LTS (`1.10`) and the latest stable (`1`) Julia, builds the package,
runs the suite, processes coverage into `lcov.info`, and uploads it to Codecov.
The matrix job name (`Julia 1.10 - ubuntu-latest - x64`) is the **required
status check** in the `main` ruleset — it is deliberately static (no event-name
suffix) so the check name never changes.

### 4.2 `Documentation.yml` — build & deploy docs

```yaml
name: Documentation

on:
  push:
    branches:
      - 'main'
      - 'dev'
    tags: '*'
  pull_request:
  release:
    types: [published]

jobs:
  build:
    name: Documentation
    permissions:
      contents: write
      statuses: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: julia-actions/setup-julia@v3
        with:
          version: '1'
      - name: Install dependencies
        run: julia --project=docs/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'
      - name: Build and deploy
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # If authenticating with GitHub Actions token
          DOCUMENTER_KEY: ${{ secrets.DOCUMENTER_KEY }} # If authenticating with SSH deploy key
        run: julia --project=docs/ docs/make.jl
```

Builds the documentation (which also **executes the `@example` blocks**, so a
broken example fails the build). On `dev`/tags it deploys to `gh-pages`; on PRs
and on `main` it builds only (deployment is skipped). The named job
`Documentation` is the second **required status check** in the `main` ruleset.

### 4.3 `CompatHelper.yml` — keep `[compat]` current

```yaml
name: CompatHelper
on:
  schedule:
    - cron: 0 0 * * 1
  workflow_dispatch:
permissions:
  contents: write
  pull-requests: write
jobs:
  CompatHelper:
    runs-on: ubuntu-latest
    steps:
      - name: Pkg.add("CompatHelper")
        run: julia -e 'using Pkg; Pkg.add("CompatHelper")'
      - name: CompatHelper.main()
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          COMPATHELPER_PRIV: ${{ secrets.DOCUMENTER_KEY }}
        run: julia -e 'using CompatHelper; CompatHelper.main()'
```

Runs weekly (Mondays). Opens PRs that bump the `[compat]` bounds in
`Project.toml` when dependencies release new versions. `COMPATHELPER_PRIV` is set
to the SSH deploy key so that CompatHelper's PRs **trigger CI** (PRs opened with
the plain `GITHUB_TOKEN` would not).

### 4.4 `TagBot.yml` — create release tags

```yaml
name: TagBot
on:
  issue_comment:
    types:
      - created
  workflow_dispatch:
jobs:
  TagBot:
    if: github.event_name == 'workflow_dispatch' || github.actor == 'JuliaTagBot'
    runs-on: ubuntu-latest
    steps:
      - uses: JuliaRegistries/TagBot@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          ssh: ${{ secrets.DOCUMENTER_KEY }}
```

After a release is registered in the Julia General registry, TagBot creates the
matching git tag and GitHub release. The tag is what triggers the versioned
`stable` docs deploy. Can also be run manually via *workflow_dispatch*.

### 4.5 `AutoMerge.yml` — auto-merge dependency PRs

```yaml
name: Auto-merge bot PRs

# Enables auto-merge for dependency-update PRs from Dependabot and CompatHelper.
# Auto-merge only completes once the branch ruleset's required checks pass, so a
# bump that breaks CI simply waits for a human instead of merging.
on: pull_request_target

permissions:
  contents: write
  pull-requests: write

jobs:
  dependabot:
    name: Dependabot
    runs-on: ubuntu-latest
    if: ${{ github.actor == 'dependabot[bot]' }}
    steps:
      - name: Fetch Dependabot metadata
        uses: dependabot/fetch-metadata@v3
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
      - name: Enable auto-merge
        run: gh pr merge --auto --squash "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  compathelper:
    name: CompatHelper
    runs-on: ubuntu-latest
    # CompatHelper opens its PRs from branches named compathelper/new_version/...
    if: ${{ startsWith(github.head_ref, 'compathelper/') }}
    steps:
      - name: Enable auto-merge
        run: gh pr merge --auto --squash "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Turns on GitHub's **auto-merge** for PRs from Dependabot (matched by actor) and
CompatHelper (matched by the `compathelper/` branch prefix). Neither bot merges
its own PRs — this workflow does. Because auto-merge waits for the required
status checks, a bump that breaks CI simply never merges and waits for a human.
Requires "Allow auto-merge" + "Allow squash merging" to be enabled (§6).

> CompatHelper caveat: the `compathelper` job only fires if CompatHelper's PRs
> emit a `pull_request` event. The SSH-key setup in §4.3 is meant to ensure
> that. If it turns out the job never runs, give CompatHelper a dedicated PAT
> instead of the deploy key.

---

## 5. Other configuration files

### 5.1 `.github/dependabot.yml` — dependency update config

```yaml
# https://docs.github.com/github/administering-a-repository/configuration-options-for-dependency-updates
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/" # Location of package manifests
    schedule:
      interval: "weekly"
```

Tells Dependabot to check for new versions of the GitHub Actions used in the
workflows once a week and open PRs to bump them. (Julia package deps are handled
by CompatHelper, not Dependabot — there is no native Julia ecosystem for
Dependabot.) **Must** be named exactly `.github/dependabot.yml` (lowercase, this
location) — it is Dependabot config, not a workflow.

### 5.2 `.github/codecov.yml` — coverage reporting

```yaml
# Codecov configuration.
# Coverage is reported but never fails a PR / blocks merging — it stays
# informational so a small dip doesn't get in the way of the auto-merge flow.
coverage:
  status:
    project:
      default:
        informational: true
    patch:
      default:
        informational: true

comment:
  layout: "reach, diff, flags, files"
  require_changes: true
```

Coverage is reported and commented on PRs, but `informational: true` means it
**never** turns a check red or blocks merging — so a small coverage dip doesn't
interfere with auto-merge. This is Codecov config, **not** a workflow; Codecov
reads it from the repo root, `.codecov.yml`, or **`.github/codecov.yml`** (where
it lives here) — never from `.github/workflows/`.

### 5.3 `CITATION.cff` — citation metadata

A [Citation File Format](https://citation-file-format.github.io/) file so GitHub
shows a "Cite this repository" button and tools can generate citations. It
contains a commented slot for the Zenodo DOI, which is minted automatically on
the next release via the GitHub–Zenodo integration.

### 5.4 Generated / ignored files

`lcov.info` (coverage) and exafmm-t's `*.dat` precomputation files are
**generated artifacts** and are listed in `.gitignore` — they must never be
committed. CI regenerates `lcov.info` on every run.

---

## 6. Required GitHub settings (web UI — not in the repo)

These are **not** stored in the repository and must be configured once in the
GitHub web interface.

### 6.1 Repository secrets
*Settings → Secrets and variables*

| Secret | Where | Purpose |
| --- | --- | --- |
| `DOCUMENTER_KEY` | Actions | SSH deploy key for docs deployment, TagBot, and CompatHelper PRs. |
| `CODECOV_TOKEN` | Actions **and** Dependabot | Coverage upload. The Dependabot copy is needed because Dependabot PRs only see Dependabot-scoped secrets. |

### 6.2 General → "Pull Requests"
*Settings → General*

- ✅ **Allow squash merging** (the auto-merge workflow uses `--squash`).
- ✅ **Allow auto-merge** (otherwise the workflow's `gh pr merge --auto` fails).
- ✅ **Automatically delete head branches** (cleans up bot branches after merge).

### 6.3 Branch ruleset: `main`
*Settings → Rules → Rulesets → New branch ruleset*

- Name `main`, Enforcement **Active**, target **Include default branch**.
- Bypass list: **Repository admin** (you), for emergencies.
- Rules:
  - ✅ Restrict deletions
  - ✅ Block force pushes
  - ✅ Require a pull request before merging — **0 required approvals**
    (so bot PRs can auto-merge unattended).
  - ✅ Require status checks to pass — add, with source **GitHub Actions**:
    - `Julia 1.10 - ubuntu-latest - x64`
    - `Documentation`
  - "Require branches to be up to date before merging": **off** (avoids
    constant re-runs across queued PRs).

### 6.4 Branch ruleset: `dev`
*Settings → Rules → Rulesets → New branch ruleset*

- Name `dev`, Enforcement **Active**, target **by pattern** `dev`.
- Rules: ✅ Restrict deletions, ✅ Block force pushes.

This protects `dev` so that "Automatically delete head branches" (§6.2) does
**not** delete `dev` when you merge a `dev → main` PR (the head branch of a
merged PR is otherwise auto-deleted, and `dev` would be the head).

> If you ever need to reset `dev` (e.g. force-push after a history cleanup),
> temporarily set this ruleset's Enforcement to **Disabled**, push, then
> re-enable.

### 6.5 Codecov

- Add the repository on [codecov.io](https://about.codecov.io/) and copy its
  upload token into the `CODECOV_TOKEN` secrets above.

### 6.6 Zenodo (optional, for citable releases)

- Enable the repository in the [GitHub–Zenodo integration](https://zenodo.org/account/settings/github/);
  a DOI is minted on the next GitHub release. Add it to `CITATION.cff`.

---

## 7. Quick checklist for a new release

1. Merge `dev → main` (PR, **merge commit**; auto-checks must pass).
2. Register the new version in the Julia General registry (e.g. comment
   `@JuliaRegistrator register` on the release commit).
3. TagBot creates the git tag + GitHub release → triggers the `stable` docs
   deploy and the Zenodo DOI.
4. Sync `main → dev` (fast-forward) to bring the version bump (and any bot
   updates) back.
