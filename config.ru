# config.ru
require 'rubygems'
require 'sinatra'

set :root, './lib'

require './lib/app'

run Filthy