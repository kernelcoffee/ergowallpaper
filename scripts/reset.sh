#!/bin/sh

rake db:reset && rake db:migrate && rm -rvf public/tree && rm -rvf public/uploads && rm -rvf public/wallpaper
