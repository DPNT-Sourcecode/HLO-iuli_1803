# How to update and release new client library

Change library version is:
- `requirements.txt`

Runner version = Client version + Runner patch
Example:
```
client version = 0.24.0
patch version = 0
runner version = 0.24.0.0
```

Update the runner version (0.X.Y.Z) in:
- `version.txt`


## To release

Commit all changes then:

```bash
export RELEASE_TAG="v$(cat version.txt)"
git tag -a "${RELEASE_TAG}" -m "${RELEASE_TAG}"
git push --tags
git push
```