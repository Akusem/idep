# Modification

In order to modify IDEP to use it for DOB, I have change and add the following code:

## In `server.R`:

Next to datapath, add the Constant:

```R
# Path to the folder where expression file are stored (accessible by DOB and IDEP)
readPath = "/srv/data/testReadFolder"
```

Next to readData, setup the use of precomputed or configured values:
```R
# Setup reactive values modifiable from server-side
rv <- reactiveValues()

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

# Inform UI of the use of precomputed data
outputOptions(output, "usePreComp", suspendWhenHidden = FALSE)
```

After, replace each occurence of `input$file1` by `rv$fileExpression`. 
This way, rv$fileExpression will correspond to user input or to precomputed value as define in URL.

## In `ui.R`

Replace `fileInput('file1', '3. Upload expression data (CSV or text)'`
by `fileInput('fileExpression', '3. Upload expression data (CSV or text)'`
for readability and consistancy.

Put the code from `radioButtons("dataFileFormat", ` to `,a( h5("?",align = "right"), href="https://idepsite.wordpress.com/data-format/",target="_blank")` in a conditionnal panel with `"!output.usePreComp"` condition:

```R
conditionalPanel("!output.usePreComp",
    radioButtons("dataFileFormat", 
    # line and line of code
    # last line before end of sidebarPanel
    ,a( h5("?",align = "right"), href="https://idepsite.wordpress.com/data-format/",target="_blank")
)
```