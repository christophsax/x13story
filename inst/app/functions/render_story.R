
# HTMLMenuLi <- function(e, id){
#   title <- attr(e, "yaml")$title
#   subtitle <- attr(e, "yaml")$subtitle
#   icon <- attr(e, "yaml")$icon

#   if (is.null(icon)) icon <- "fa-road"
#   if (is.null(subtitle)) subtitle <- "Add a subtitle to your YAML header"
#   if (is.null(title)) title <- "Add a title to your YAML header"

#   tags$li(
#     tags$a(id = id, href="#", class="media shiny-id-el shiny-force",
#       tags$div(class="media-left", 
#         tags$span(class="icon-wrap bg-danger",
#           tags$i(class="fa fa-calendar fa-lg")
#         )
#       ),
#       tags$div(class="media-body", 
#         tags$div(class="text-nowrap", title),
#         tags$small(class="text-muted", subtitle)
#       )
#     )
#   )
# }                           


# HTMLMenu <- function(STORIES){
#   # tags$p("dsfsdfsd")
  
#   tagList(
#     tags$div(id="iSelectorFeedback", class="shiny-id-callback",
#       tags$ul(class = "head-list", 
#         tagList(
#         Map(HTMLMenuLi, e = STORIES, id = names(STORIES))
#         )
#       )
#     ),
#     tags$script('
#           $(".shiny-id-el").click(function() {
#                 $(".shiny-id-el").removeClass("active");
#                 $(this).addClass("active");
#               });
#       '
#     )
#   )
# }




# HTMLx13view <- function(view, title = "My Story"){

#   # if first or last, buttons are disabled
#   p.button <- tags$button(id = "prev", class = "btn btn-primary shiny-id-el", style="margin-right: 6px", type = "button", "Prev")
#   n.button <- tags$button(id = "next", class = "btn btn-primary shiny-id-el", type = "button", "Next")
  
#   if (view$first) p.button$attribs$disabled <- NA
#   if (view$last) n.button$attribs$disabled <- NA

#   tagList(
#     tags$div(id="iStoryFeedback", class="panel shiny-id-callback",
#       tags$div(class = "panel-heading",
#         tags$div(class = "panel-control",
#           tags$div(class = "box-inline",
#             tags$span(
#               p.button
#             ),
#             tags$span(
#               n.button
#             )
#           ),
#           tags$button(id = "close", class = "btn btn-default shiny-id-el", tags$i(class = "fa fa-times"))
#         ),
#         tags$h3(class = "panel-title", title)
#       ),
#       tags$div(class = "progress progress-sm", 
#         tags$div(style = paste0("width: ", view$percent, "%;"), class = "progress-bar progress-bar-info")
#       ),
#       tags$div(class = "panel-body story-body", 
#         HTML(view$body.html)
#       )
#     ),
#     tags$script('
#           $(".shiny-id-el").click(function() {
#                 $(".shiny-id-el").removeClass("active");
#                 $(this).addClass("active");
#               });
#       '
#     )
#   )
# }









#                             <div id="story-panel" class="panel" >  
#                                 <div class="panel-heading">



#                                     <div class="panel-control">

#                                     <div class="box-inline">
#                                         <span id="oNextButton" class="shiny-html-output"></span>
#                                         <span id="oPreviousButton" class="shiny-html-output"></span>
#                                     </div>

#                                         <button id="story-hide" class="btn btn-default"><i class="fa fa-times"></i></button>




#                                     </div>


# <!--                                     <h3 class="panel-title">The X-11 Method</h3>
#  -->                                 


#                                     <div id="oStorytitle" class="shiny-html-output"></div>

#                                 </div>

#                                 <div id="oStoryprogress" class="shiny-html-output"></div>


#                                 <div class="panel-body">
#                                     <div id="oStorytext" class="shiny-html-output"></div>
#                                 </div>

#                             </div>




# render_story <- function(file){

#   ff <- readLines(file)

#   # parse yampl
#   yamltxt <- ff[(grep("---", ff)[1] + 1):(grep("---", ff)[2] - 1)]
#   yamlsplt <- strsplit(yamltxt, ":")
#   yaml <- sapply(yamlsplt, function(e) e[2])
#   yaml <- gsub("^ *| *$", "", yaml)
#   names(yaml) <- sapply(yamlsplt, function(e) e[1])

#   # lines starting with double hash
#   nstart <- grep("^ *## ", ff)
#   nend <- c((nstart-1)[-1], length(ff))

#   # separate in storypages
#   ss <- Map(function(e1, e2) ff[e1:e2], e1 = nstart, e2 = nend)

#   z <- lapply(ss, render_storypage)

#   # add page num
#   z <- Map(function(e1, e2) c(e1, list(pageno = c(e2, length(z)))), e1 = z, e2 = seq(z))


#   attr(z, "yaml") <- yaml
#   class(z) <- "story"
#   z

# }



# render_storypage <- function(pp){
#   # parsing the title
#   title <- gsub("^ *## *| $", "", pp[1])

#   # lines with three backticks 
#   # the first range is storpage info, after the range, content starts
#   nbt <- grep("```", pp)[1:2]

#   if (length(nbt) != 2) stop("missing or invalid backtick area for storypage ", title)

#   spi <- pp[(nbt[1] + 1):(nbt[2] - 1)]
#   cnt <- pp[(nbt[2] + 1):length(pp)]

#   # drop empty lines and comments
#   spi <- spi[!grepl("^ *$|^ *#", spi)]

#   # parsing the storypage info
#   nn <- gsub("^(.+?):.*", "\\1", spi)
#   cc <- gsub("^.+?:(.*)", "\\1", spi)
#   z <- lapply(cc, function(e) parse(text = e)[[1]])
#   names(z) <- nn

#   # parsing the content

#   render_md_to_html <- function(x){
#     tfile <- paste0(tempfile(), ".md")
#     writeLines(x, tfile)
#     html <- markdown::markdownToHTML(tfile, fragment.only = TRUE)
#     file.remove(tfile)
#     html
#   }

#   z$story <- render_md_to_html(cnt)
#   class(z) <- "storypage"
#   z
# }







