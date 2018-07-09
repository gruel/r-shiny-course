# Build the artefacts required for the RSE 2018 Workshop on Shiny
#
# David Mawdsley
.PHONEY: runrstudio stoprstudio dockerimage

presentationname=WorkshopSlides
sourcedata = $(wildcard sourcedata/*)



$(presentationname)_annote.Rmd: $(presentationname).Rmd
	cp $< $@

$(presentationname).html: $(presentationname)_annote.Rmd coursematerial/plottingFunctions.R coursematerial/gapminder.rds  present.css
	Rscript -e "rmarkdown::render('$<', output_file='$@')"

present: $(presentationname).html
	chromium-browser $< &

dockerimage: Dockerfile	
	docker build . -t mawds/rstudio

coursematerial/gapminder.rds: createData.R $(sourcedata) 
	Rscript $<

runrstudio: 
	docker run --rm -d --name rstudio -p 8787:8787 -p 3838:3838  -v "$$(pwd)/coursematerial:/home/rstudio/coursematerial" -e USERID=$UID  mawds/rstudio

stoprstudio:
	docker stop rstudio

