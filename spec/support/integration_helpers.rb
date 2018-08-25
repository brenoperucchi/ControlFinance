def show_page(store=nil)
  save_page Rails.root.join( 'public', 'capybara.html' )
  %x(launchy http://#{store.url.first}.localhost:3000/capybara.html)
end