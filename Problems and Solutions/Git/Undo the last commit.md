git reset --soft HEAD~1

In Git:

- **`--soft`**: Moves the HEAD pointer to the previous commit but keeps the changes in the staging area (index). This allows you to modify the commit or re-commit the changes.

- **`--hard`**: Moves the HEAD pointer to the previous commit and discards all changes in the working directory and staging area. This is irreversible unless you have backups or reflog enabled.