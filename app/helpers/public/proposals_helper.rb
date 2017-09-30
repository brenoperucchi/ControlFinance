module Public::ProposalsHelper
  
  def create_field(f)
    fields = capture do
      concat(content_tag(:div, class: 'form-group') do   
        concat(content_tag(:label, '/variable/', class: 'control-label string required'))

        concat(text_field_tag "#{f[:f].object_name}[/variable/]", nil, class: 'form-control string required', data:{validate:true})
      end)
    end
  end

  def link_new_field(name, f)
    fields = capture do
      concat(content_tag(:div, class: 'add-field form-group') do   
        concat(content_tag(:div, class: 'input-group m-t-10') do 
          concat(text_field_tag 'name', nil, id:'inputName', class: 'new_field form-control string require', required: "")
          concat(content_tag(:div, '', class: 'help-block with-errors'))
          concat(content_tag(:div, class: 'create-field input-group-btn', style:'vertical-align:top;') do 
            concat(content_tag(:a, '', class: 'm-l-5 btn btn-success', id:'create-field', type: :submit, data:{fields:create_field(f).gsub("\n", "")}) do
              concat ("Create")
              concat (content_tag :i, '', class: 'm-l-5 fa fa-check')
            end)
          end)
        end)
      end)
    end
    link_to name, '#', class: "new_field", data: {fields: fields.gsub("\n", "")}
  end
end