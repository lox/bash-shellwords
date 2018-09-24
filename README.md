# Tokenizing a quoted shell string in bash

So, you have a string with shell commands in it and you want to parse it into tokens, respecting single and double quotes like posix shells do?

Well, it turns out to be really hard [1][2] to do without using `eval`, which leads to huge security holes if you are trusting user input. This is a bash function that will do that for you, and it will exit if any of the string arguments require a shell to actually interpolate. We use this to auto-detect if a command can be directly exec'd or whether it needs to be passed to /bin/bash in buildkite-agent.

## Usage

```bash
result=()
tokenize_shell_string "this is a 'quoted string'"

for arg in "${result[@]}" ; do
  echo $arg
done

# this
# is
# a
# quoted string
```

## Output

The `tokenize_shell_string` function populates a global bash array called `$result`. It will return an code of `0` if all went well, `1` if there is a parse error and `100` if any special shell characters are detected unquoted.

[1]: https://superuser.com/questions/1066455/how-to-split-a-string-with-quotes-like-command-arguments-in-bash
[2]: https://stackoverflow.com/questions/12821302/split-a-string-only-by-spaces-that-are-outside-quotes/12823008#12823008
