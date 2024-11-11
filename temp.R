devtools::install()
devtools::load_all()


rmarkdown::draft(
  file = "test.Rmd", # Path to the new file you want to create
  template = "omni", # Template name as defined in template.yaml
  package = "omni", # Package name containing the template
  create_dir = FALSE # Set TRUE if you want it in a new directory
)
