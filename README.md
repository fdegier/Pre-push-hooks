# Pre-push hooks  

Hooks are awesome, depending on the hooks you use, it can save you a lot of headaches. 

I particularly like pre-push hooks as it will allow me to commit whenever I want and not spend a lot of time
waiting for the pre-commit hooks, then once I'm ready to push my code I'll clean everything up and squash the commits. 

Ultimately I would like to add a collection of useful pre-push hook to this repository.

## Check for merge conflicts

One of the things I hadn't captured in a hook was merge conflicts and it started to annoy me when I push my code
and instantly get an email stating that my MR no longer can be merged due to a conflict. So I've created this hook.

It will check your current branch against the "default" branch if they are capable of merging without conflicts. 
If they aren't the hook will fail and alert you of an upcoming merge conflict.

## Usage

There are two ways to use the hooks in this repository. 

### Multiple hooks

Only 1 file per hook type is allowed, this is a bit troublesome if you have multiple hooks for the same type. 
Within `hooks` you will find a file called `pre-push` which essentially runs all the files in the corresponding 
directory `pre-push.d`. In that directory you can put as many hooks as you want.

```bash
cp -r hooks/pre-push.d/ ~/some_repo/.git/hook/pre-push.d
cp hooks/pre-push ~/some_repo/.git/hook/pre-push

# Then make the file executable 
chmod +x ~/some_repo/.git/hooks/pre-push
chmod +x ~/some_repo/.git/hooks/pre-push.d
```


### Single hook

In case you want a single hook, just copy the contents of the hook, or copy the hook to the repository that you want 
to use it in. 

```bash
cp hooks/pre-push.d/mr-conflicts ~/some_repo/.git/hook/pre-push

# Then make the file executable 
chmod +x ~/some_repo/.git/hooks/pre-push
```

## Globally

If you want to use hooks for all your repositories, you can!

```bash
mkdir -p ~/.git-templates

cp -r hooks ~/.git-templates/
chmod +x ~/.git-templates/hooks/**/*

git config --global init.templatedir '~/.git-templates'
```

