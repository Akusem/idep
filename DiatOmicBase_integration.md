# Modification

In order to modify IDEP to use it for DOB, I have changed and added the following code:

## In `server.R`:

Update `datapath` value to `/srv/data`.

Next to datapath, add the Constant:

```R
# Path to the folder where expression file are stored (accessible by DOB and IDEP)
readPath = "/srv/data/testReadFolder"
# Phaeo GMT file name, for Phaeo support in enrichment
gmtFile = "Phatr3.gmt"
```

Next to readData, setup the use of precomputed or configured values:
```R
# Setup reactive values modifiable from server-side
rv <- reactiveValues()

# Deactivate example file 
rv$goButton <- 0
# Select Phaeo as default species
rv$selectOrg <- "BestMatch" # Set to 'BestMatch' when multiple species would need to be supported
# Was using GMT file previously before modifing the database 
rv$gmtFile <- data.frame(
				name=c(gmtFile),
				type=c("text/plain"),
				size=c(10),
				datapath=c(file.path(readPath, gmtFile))
			)


# Look at URL params to determine if it should use precomputed data or not
# Setup rv$fileExpression, so it use precomputed or user file depending on the URL params
output$usePreComp <- reactive({
		query <- parseQueryString(session$clientData$url_search)
		if (!is.null(query[["usePreComp"]])) {
			tmpDf = data.frame(
				name=c(query[["fileName"]]),
				type=c("text/plain"),
				size=c(10),
				datapath=c(file.path(readPath, query["fileName"]))
			)
			rv$fileExpression <- tmpDf
			return(TRUE)
		} else {
			rv$fileExpression <- input$fileExpression
			return(FALSE)
		}
	})

# Inform UI of the use of precomputed data or not
outputOptions(output, "usePreComp", suspendWhenHidden = FALSE)
```

After, replace each occurence of `input$file1` by `rv$fileExpression`. 
This way, rv$fileExpression will correspond to user input or to precomputed value as define in URL.

Replace `input$goButton` by `rv$goButton`
Replace `input$selectOrg` by `rv$selectOrg`
Replace `input$gmtFile` by `rv$gmtFile`

Close the wait for library message by adding `shinyjs::hideElement(id = "waitForLibrary")` in 
output$fileFormat, next to hideElement for loadMessage:

```R
output$fileFormat <- renderUI({
  shinyjs::hideElement(id = 'loadMessage')
  shinyjs::hideElement(id = "waitForLibrary") # Line to add
```

In the Server function part, after `speciesChoice` initialization, so just after this piece of code:
```r
i= which(names(speciesChoice) == "Human"); speciesChoice <- move2(i)
```

Add the `speciesChoice` that will be used, to display only the species we want.
It is a list of numbers, corresponding to the species number in `convertID.db`.
The speciesName is setup as names for each element of the list.

```R
speciesChoice = list("BestMatch", "499")
names(speciesChoice) <- c("Best matching species", "Phaeodactylum tricornutum")
```

## In `ui.R`

Replace `fileInput('file1', '3. Upload expression data (CSV or text)'`
by `fileInput('fileExpression', '3. Upload expression data (CSV or text)'`
for readability and consistancy.

Put the code from `radioButtons("dataFileFormat", ` to `,a( h5("?",align = "right"), href="https://idepsite.wordpress.com/data-format/",target="_blank")` in a conditionnal panel with `"!output.usePreComp"` condition:

Also, Add the h5 waitForLibrary like below:

```R
conditionalPanel("!output.usePreComp",
    # h5 to add
    h5("Wait for library loading", style="color:red", id="waitForLibrary"),
    # Code already present
    radioButtons("dataFileFormat", 
    #
    # line and line of code
    #
    # last line before end of sidebarPanel
    ,a(h5("?",align = "right"), href="https://idepsite.wordpress.com/data-format/", target="_blank")
)
```

Put in comment the code from `actionButton("goButton", "Click here to load demo data")` to
the end of the conditionPanel for the selectOrg (containing the fileInput for gmtFile) 

Replace menu in mainPanel with :

```R
      shinyjs::useShinyjs(),
      tableOutput('sampleInfoTable')
      ,tableOutput('contents')

      ,div(id='loadMessage',
           h4('Loading R packages, please wait ... ... ...'))
      ,htmlOutput('fileFormat')
      ,h3(id='betaWarning', style='color: red', 'This is a Beta version, don\'t hesitate to report any issues at', a("diatomicbase@bio.ens.psl.eu", href="mailto:diatomicbase@bio.ens.psl.eu"))
      ,h3("This analysis is proposed using iDEP v.0.94, with Phaeodactylum data added")
      ,h4("If you use this analytic module, please cite:")
      ,h4("Ge, S.X., Son, E.W. & Yao, R. iDEP: an integrated web application for differential expression and pathway analysis of RNA-Seq data. BMC Bioinformatics 19, 534 (2018).", a("https://doi.org/10.1186/s12859-018-2486-6", href="https://doi.org/10.1186/s12859-018-2486-6"))
      ,br(),img(src='flowchart.png', align = "center",width="562", height="383")

```

Remove the `Network (New!)` in red by replace them with simply `Network`, and removing the:
```R
tags$head(tags$style("#ModalVisNetworkDEG{color: red}"))
```



Remove the Google Analytics script at the end of ui file:
```R
  ,tags$head(includeScript("ga.js")) # tracking usage  
```

You can also delete ga.js in the idep folder.

Add at the start or the end setTitle.js
```R
	,tags$head(includeScript("setTitle.js"))
```

Update App title (named `iDEPversion`), and make the link with DOB by adding the following code after the library call:

```R
dobUrl = Sys.getenv("DOB_URL") # Get Href to DiatOmicBase
if (nchar(dobUrl) == 0) {
  message("Warning: DiatOmicBase URL isn't setup")
}
iDEPversion = tags$a("iDEP.94 (DiatOmicBase's instance)", style="color: #1f8ca4", href=paste(dobUrl, "transcriptomicsChoice", sep=""))
```
