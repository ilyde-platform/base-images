options(repos=structure(c(CRAN="https://cran.rstudio.com")))

.ilyde.IsSvgAvailable <- function () {
  return(capabilities('cairo'))
}

.ilyde.SetupDefaultGraphicsDeviceAsResult <- function () {
  if (.ilyde.IsSvgAvailable()) {
    grDevices::svg(filename = "results/Rplot%03d.svg", onefile = FALSE)
  } else {
    grDevices::pdf(file = "results/Rplot%03d.pdf", onefile = FALSE)
  }
}

# RStudio will set the env variable RSTUDIO=1 when it runs
if (Sys.getenv("RSTUDIO") != 1) {
  setHook(
    packageEvent("grDevices", "onLoad"),
    function(...) {
      # cat('[ilyde] Setting default graphics to output to results/ folder...\n')
      .ilyde.SetupDefaultGraphicsDeviceAsResult()
    }
  )
}

.ilyde.dumpFrames <- function () {
  cat("[ilyde] Saving output of dump.frames to 'ilyde.last.dump.Rda'. You can load it with R's 'debugger' function to debug your script.\n", file = stderr())
  dump.frames(dumpto = "ilyde.last.dump", to.file = TRUE)
}

.ilyde.dumpWorkspace <- function () {
  totalBytes = sum(sapply(ls("package:base", all.names=TRUE), function(theObj) object.size(get(theObj))))
  twoGB = 2 * 1024 * 1024 * 1024
  if (totalBytes < twoGB) {
    cat("[ilyde] Saving your workspace to 'ilyde.workspace.RData' in case you want to access your intermediate results.\n", file = stderr())
    save.image(file = "ilyde.workspace.RData")
  } else {
    cat("[ilyde] Your workspace was more than 2GB, so we are not saving it for you, sorry.\n", file = stderr())
  }
}

.ilyde.handleError <- function () {
  # RStudio will set the env variable RSTUDIO=1 when it runs
  if (!exists(".ilyde.notebook") & Sys.getenv("RSTUDIO") != 1) {
    # Create dump files to help debug scripts that were not executed as a notebook.
    .ilyde.dumpFrames()
    .ilyde.dumpWorkspace()
    # Abort script (except for notebook sessions).
    q(status = 1)
  }
}

