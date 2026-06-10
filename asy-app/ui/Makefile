vpath %.asy icons
vpath %.asy logo
vpath %.svg src/assets
vpath %.html.gz public

ASY_ICONS=$(wildcard icons/*.asy)
ASY_LOGO=logo3d.html.gz

all:	$(notdir $(ASY_ICONS:.asy=.svg)) $(ASY_LOGO) node_modules
	npm run build
	-cd build && rm static/js/*.LICENSE.txt

node_modules: package.json
	npm install

clean:
	-cd src/assets && rm -f $(notdir $(ASY_ICONS:.asy=.svg)) show.svg homeHover.svg
	-cd public && rm -f $(ASY_LOGO)
	-rm -rf node_modules build package-lock.json

.SUFFIXES: .asy .svg .html .gz .html.gz

%.svg: %.asy
	asy -nowarn unbounded -f svg -o src/assets/ $<

%.html: %.asy
	asy -nowarn unbounded -f html -o public/ $<

%.html.gz: %.html
	cd public && gzip -f $<
