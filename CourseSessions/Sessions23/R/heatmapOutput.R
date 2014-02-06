
#  Copyright 2013, Satrapade
#  by V. Kapartzianis 
#  Dual licensed under the MIT or GPL Version 2 licenses.

heatmapOutput <- function(outputId) {
  uiOutput(outputId)
}

renderHeatmapX <- function(data, style="norm", include.rownames = TRUE, include.colnames=TRUE, nsmall=2, border=0) {
  vmax <- max(Filter(is.numeric, data))
  sigmoid <- function(v) { return(1 / (1 + exp(-v))) }
  toRGB <- function(intensity, sign) {
    rgb <- "rgb("
    darkness <- floor((1 - intensity) * 256)
    if(sign) 
      rgb <- paste(rgb, darkness, ",255,", darkness, sep="")
    else
      rgb <- paste(rgb, "255,", darkness, ",", darkness, sep="")
    rgb <- paste(rgb, ")", sep="")
    return (rgb)
  }
  heatmap <- function(x, style="norm") {
    if ("squashed" == style) {
      squashed <- sigmoid(x) - 0.5
      intensity <- abs(squashed) / 0.5
      rgb <- toRGB(intensity, squashed >= 0)
    } else { # ("norm" == style)
      intensity <- abs(x) / vmax
      rgb <- toRGB(intensity, x > 0)
    }
    return (paste("background-color:", rgb))
  }
  if (is.null(colnames(data))) colnames(data) <- 1:ncol(data)
  if (is.null(rownames(data))) rownames(data) <- 1:nrow(data)  
  as.character(
    tags$table(
      border = border,
      class = 'data table table-bordered table-condensed',
      tagList({
        if (include.colnames)
          tags$thead(
            class = 'thead',
            tags$tr(
              tagList({
                if (include.rownames)
                  tags$th()
                else
                  list()
              }),
              lapply(colnames(data), function(name) {
                tags$th(name)
              })
            )
          )
        else
          list()
      }),
      tags$tbody(
        lapply(1:nrow(data), function(i) {
          tags$tr(
            tagList({
              if (include.rownames)
                tags$td(
                  align="right",
                  rownames(data)[i]
                )
              else
                list()
            }),
            lapply(1:ncol(data), function(j) {
              if (is.numeric(data[i,j]))
                tags$td(
                  align="right",
                  style=heatmap(data[i,j], style),
                  format(data[i,j], nsmall=nsmall)
                )
              else
                tags$td(
                  as.character(data[i,j])
                )
            })
          )
        })
      )
    )
  )
}

renderHeatmap <- function(expr, ..., env=parent.frame(), quoted=FALSE) {
  # Convert expr to a function
  func <- shiny::exprToFunction(expr, env, quoted)
  function() renderHeatmapX(func(), ...)
}