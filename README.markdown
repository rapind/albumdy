Albumdy
=======

Albumdy is a very simple Ruby on Rails photo gallery. Includes only simple photo management and categorization via albums. A decent starting point for your own rails based gallery.

For more of a professional photographer solution, please see [http://www.grokphoto.org](http://www.grokphoto.org).

There's a live demo available at:

* [http://www.albumdy.org](http://www.albumdy.org)

You can access the public area at:

* [http://demo.albumdy.org](http://demo.albumdy.org)

You can access the admin area at:

* [http://demo.albumdy.org/admin](http://demo.albumdy.org/admin)
* Email: demo@albumdy.org
* Password: password


Software Requirements
---------------------

* ImageMagick
* MySQL (I haven't tested it with Postgres or sqlite3, but it *should* work.)

Installation
------------

Installation script coming soon! Follow these instructions for now:

    $ git clone git://github.com/rapind/albumdy.git
    $ cd albumdy
    $ cp config/database.yml.sample config.database.yml
    $ cp config/initializers/albumdy.rb.sample config/initializers/albumdy.rb
    $ cp config/deploy.rb.sample deploy.rb

Then edit these three files with your own settings. Everything you need to change is marked with a "TODO":

    $ sudo gem install less
    $ sudo rake gems:install
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed
    $ script/server

At this point you should have a working site with some basic sample data that you can configure with your own data.

Initial Configuration
---------------------

1. Login to the administration area using demo@albumdy.org / password
2. Click on the Settings tab.
3. Enter your own information and update the settings.
4. Albums holds the front page slide images and the photos within each of your albums.

Features
--------

* Personalize your site via the configuration / settings page.
* Manage your albums and photos.
* Friendly slugs for your albums and pages (SEO).
* Google compliant sitemap.
* Google analytics integration.
* Flash based front page image slides.
* Javascript based photo albums.
* Stats on when your clients last logged in (good to know if they haven't visited their booking gallery before it expired).


Themes
------

ERB and HAML based themes are supported and can be found in the /themes directory (off the project's root).

I've tried to keep these as simple as possible for now and they're just for the public area of your site. I don't see the value in theming the admin section for now.

Each theme has it's own directory, and the easiest way to get started building your theme is to copy the default theme to a new directory. I.e. "cp -r themes/default themes/mycustomtheme"

Credits
-------

* [http://github.com/thoughtbot/paperclip](http://github.com/thoughtbot/paperclip)
* [http://github.com/josevalim/inherited_resources](http://github.com/josevalim/inherited_resources)
* [http://github.com/binarylogic/authlogic](http://github.com/binarylogic/authlogic)
* [http://github.com/nex3/haml](http://github.com/nex3/haml)
* [http://github.com/cloudhead/less](http://github.com/cloudhead/less)
* [http://devkick.com/lab/galleria/](http://devkick.com/lab/galleria/)
* [http://www.progressivered.com/cu3er/](http://www.progressivered.com/cu3er/)
* Sample photos were provided by and are copyright of Jaime Coyle Photography [http://jaimecoyle.com](http://jaimecoyle.com)


License
-------

<a rel="license" href="http://creativecommons.org/licenses/by-sa/2.5/ca/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/2.5/ca/88x31.png" /></a><br /><span xmlns:dc="http://purl.org/dc/elements/1.1/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dc:title" rel="dc:type">Grokphoto</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://github.com/rapind/albumdy" property="cc:attributionName" rel="cc:attributionURL">http://github.com/rapind/albumdy</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/2.5/ca/">Creative Commons Attribution-Share Alike 2.5 Canada License</a>.<br />Based on a work at <a xmlns:dc="http://purl.org/dc/elements/1.1/" href="http://github.com/rapind/albumdy" rel="dc:source">github.com</a>.
