# Connect to Qualtrics

This function connect to Qualtrics. It calls omni::qualtrics_register
behind the scenes to provide a connection if no API key and URL are
registered (or if they are expired). In that case, please provide
\`api_key\` and \`base_url\`

## Usage

``` r
qualtrics_connect(organization_name = "OMNI", api_key = "", base_url = "")
```

## Arguments

- organization_name:

  Organization name

- api_key:

  Your Qualtrics API key

- base_url:

  Base URL

## Value

Connection to Qualtrics
