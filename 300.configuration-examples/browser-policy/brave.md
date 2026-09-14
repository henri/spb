Configuring System Wide Brave Browser Search Policy (LINUX)

<hr>

```
# This example will set all brave (and brave origin) instances to use brave search
# using this approach requires sudo access on the system.

# This approach makes use of a recommended policy to alter the brave settings.
# this option is able to overridden by user by editing browser settings.

sudo mkdir -p /etc/brave/policies/recommended
sudo tee /etc/brave/policies/recommended/search.json > /dev/null << 'EOF'
{
  "DefaultSearchProviderEnabled": true,
  "DefaultSearchProviderName": "Brave",
  "DefaultSearchProviderSearchURL": "https://search.brave.com/search?q={searchTerms}",
  "DefaultSearchProviderSuggestURL": "https://search.brave.com/api/suggest?q={searchTerms}"
}
EOF

# Policy settings may be viewed by visiting : brave://policy/

# Temporary disable recommended policies by running command below
# sudo mv -i /etc/brave/policies/recommended /etc/brave/policies/recommended.disabled
```

<hr>
<br>

```
# This example will set all brave (and brave origin) instances to use brave search
# using this approach requires sudo access on the system.

# This approach makes use of a recommended policy to alter the brave settings.
# this option is ***NOT*** able to be overridden by users running brave browser.

sudo mkdir -p /etc/brave/policies/managed
sudo tee /etc/brave/policies/managed/search.json > /dev/null << 'EOF'
{
  "DefaultSearchProviderEnabled": true,
  "DefaultSearchProviderName": "Brave",
  "DefaultSearchProviderSearchURL": "https://search.brave.com/search?q={searchTerms}",
  "DefaultSearchProviderSuggestURL": "https://search.brave.com/api/suggest?q={searchTerms}"
}
EOF

# Policy settings may be viewed by visiting : brave://policy/

# Temporary disable managed policies by running command below
# sudo mv -i /etc/brave/policies/managed /etc/brave/policies/managed.disabled

```

<hr>

