# `ModuleNotFoundError` with `py_venv` in `aspect_rules_py` 1.6.3

Minimal reproduction case demonstrating `ModuleNotFoundError` when importing internal libraries in virtual environments created with `py_venv` targets in `aspect_rules_py` 1.6.3. The issue occurs because the `{target_name}.venv.pth` file is not generated, which prevents internal library paths from being added to `sys.path` when the virtual env is activated.

## Issue

When using `py_venv` targets with `aspect_rules_py` 1.6.3, attempting to import internal libraries results in:
```
ModuleNotFoundError: No module named 'calculator'
```

**Root cause:** The `{target_name}.venv.pth` file (where `{target_name}` is the target name, e.g., `venv` → `venv.venv.pth`) is not generated in the virtual env in version 1.6.3, preventing internal library paths from being added to `sys.path`. This file was gets created in virtual env in version 1.4.0.

**Additional issue:** The virtual env name is not displayed in the terminal prompt. In version 1.4.0, the prompt shows `(.venv.venv) ➜ python-bazel-project`, but in 1.6.3 this indicator is missing.

## Steps to repro this issue:

```bash
# 1. Create venv
bazel run //app:venv

# 2. Activate venv
source .app+venv/bin/activate

# 3. Run app (fails with ModuleNotFoundError)
python app/main.py
```

**Expected:** App runs successfully; terminal shows `(.venv.venv) ➜`  
**Actual:** `ModuleNotFoundError: No module named 'calculator'`; no venv indicator in terminal prompt

## Regression Test

```bash
bazel test //app:venv_test  --test_output=all
```

- Test PASSES when imports work correctly (no regression)  
- Test FAILS when `ModuleNotFoundError` occurs (regression detected)

The test creates a venv, activates it, and verifies that internal libraries can be imported.

## Workaround

Change `aspect_rules_py` version to `1.4.0` in `MODULE.bazel` - everything works correctly:
- `ModuleNotFoundError` is resolved - internal libraries can be imported
- The `.pth` file is generated (root cause fixed)
- virtual env name is displayed in terminal prompt: `(.venv.venv) ➜`

## Repository Structure

- `lib/calculator/` - Internal library with external dependency (requests)
- `app/` - Application using the internal library

For complete issue details, see `GITHUB_ISSUE.md` or `ISSUE_TEMPLATE.md`.

