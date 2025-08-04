Cherry-picking in Git means applying the changes from specific commits on one branch onto another branch. This is useful when you want to bring in changes without merging an entire branch.

### 🔧 Basic Steps to Cherry-Pick Commits

#### 1. **Checkout the branch you want to apply the commits to**

```bash
git checkout your-target-branch
```

#### 2. **Cherry-pick the commit**

You need the commit hash (you can get it with `git log`).

```bash
git cherry-pick <commit-hash>
```

You can cherry-pick multiple commits at once:

```bash
git cherry-pick <hash1> <hash2> <hash3>
```

Or a range of commits:

```bash
git cherry-pick <start-commit>^..<end-commit>
```

> The `^` includes the start commit.

---

### 📌 Example Scenario

You’re on branch `main` and want to apply a few commits from `feature-branch`:

```bash
git checkout main
git cherry-pick a1b2c3d  # Apply one commit
```

If you want to cherry-pick a range from `feature-branch`:

```bash
git checkout main
git cherry-pick feature-branch~3..feature-branch
```

> This picks the last 3 commits from `feature-branch`.

---

### ⚠️ What if there are conflicts?

Git will pause and let you fix the conflicts.

1. Fix the conflict in your editor.
2. Stage the resolved files:

   ```bash
   git add .
   ```
3. Continue the cherry-pick:

   ```bash
   git cherry-pick --continue
   ```

To abort the cherry-pick:

```bash
git cherry-pick --abort
```

---

### ✅ Tips

* Use `git log --oneline` to get commit hashes quickly.
* Try `git cherry-pick -n <commit>` to apply changes without committing immediately.
* Consider using `rebase` instead of cherry-pick if you're syncing multiple commits in a sequence and want cleaner history.

Let me know your specific scenario and I can walk you through it with exact commands.
