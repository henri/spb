Configuring System Wide Brave Browser Search Policy

```
# This example will set all brave instances to use brave search
# using this approach requires sudo access on the system.

# This approach is setting this setting via a policy which means
# this option is not overridden by user settings.

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
```
