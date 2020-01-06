require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('create an album path', {:type => :feature}) do
  it('creates an album and then goes to the album page') do
    visit('/albums')
    click_on('Add a new album')
    fill_in('album_name', :with => 'Yellow Submarine')
    click_on('Add album')
    expect(page).to have_content('Yellow Submarine')
  end
end

describe('create a song path', {:type => :feature}) do
  it('creates an album and then goes to the album page') do
    album = Album.new({:name => "Yellow Submarine", :id => nil})
    album.save
    visit("/albums/#{album.id}")
    fill_in('song_name', :with => 'All You Need Is Love')
    click_on('Add song')
    expect(page).to have_content('All You Need Is Love')
  end
end

describe('re-route from Nil album Id', {:type => :feature}) do
  it('displays a page with information for re-directing') do
    visit("/albums/13")
    click_on('Return to album list')
    expect(page).to have_content('All Sales Vinyl')
  end
end

describe('re-route from Nil song ID', {:type => :feature}) do
  it('displays a page with information for re-directing or adding a song') do
    album = Album.new({:name => "Yellow Submarine", :id => nil})
    album.save
    visit("/albums/#{album.id}/songs/32")
    expect(page).to have_content('Uh oh, that song doesn\'t seem to exist, would you like to add it?')
    fill_in('song_name', :with => 'All You Need Is Love')
    click_on('Add song')
    expect(page).to have_content('All You Need Is Love')
  end
end
