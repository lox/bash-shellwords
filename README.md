# Parsing a quoted shell string in bash

So, you have a string with shell commands in it and you want to parse it into tokens, respecting single and double quotes like posix shells do?

Well, it turns out to be really hard. This is a bash function that will do that for you, and it will exit if any of the string arguments require a shell to actually interpolate. We use this to auto-detect if a command can be directly exec'd or whether it needs to be passed to /bin/bash in buildkite-agent.

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

