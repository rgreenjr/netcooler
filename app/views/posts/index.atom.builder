xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  xml.title "Netcooler - #{@company.name} - #{@category.pluralize}"
  xml.link :rel => "self", :href => atom_url(@company, @category) + '.atom'
  xml.updated Time.now.to_s(:rfc3393)
  xml.author do
    xml.name "Netcooler"
  end
  xml.id "tag:netcooler.com,#{@company.created_at.strftime('%Y-%m-%d')}:/companies/#{@company.id}/#{@category}"
  render :partial => "posts/entry", :collection => @posts, :locals => { :xm => xml }
end
