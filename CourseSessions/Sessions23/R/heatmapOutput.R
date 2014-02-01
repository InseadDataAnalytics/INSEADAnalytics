
#  Copyright 2013, Satrapade
#  by V. Kapartzianis 
#  Dual licensed under the MIT or GPL Version 2 licenses.

heatmapOutput <- function(outputId) {
  uiOutput(outputId)
}

renderHeatmapX <- function(data, style="norm", include.rownames = TRUE, include.colnames=TRUE, nsmall=2, border=0, center = NULL, vrange_up = NULL, vrange_down = NULL, minvalue = 0) {
  center = ifelse(is.null(center), mean(Filter(is.numeric, data)), center)
  vrange_up = ifelse(is.null(vrange_up), abs(max(Filter(is.numeric, data-center))), vrange_up)
  vrange_down = ifelse(is.null(vrange_down), abs(min(Filter(is.numeric, data-center))), vrange_down)  
  vrange <- max(Filter(is.numeric, data)) - min(Filter(is.numeric, data))

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
      squashed <- sigmoid(ifelse(vrange, 4*(x-center)/vrange, 0))- 0.5
      intensity <- abs(squashed) / 0.5
      rgb <- toRGB(intensity, squashed >= 0)
    } else { # ("norm" == style)
      xdemean = ifelse(abs(x-center) > minvalue, x-center, 0)
      intensity <- ifelse(xdemean > 0, abs(xdemean/vrange_up), abs(xdemean/vrange_down))
      rgb <- toRGB(intensity, xdemean > 0)
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