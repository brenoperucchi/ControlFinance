module Public::ProposalsHelper

  def status_value_helper(unit)
    content_tag
  end
  # td.lo-stats__status
  #   .d-table.mx-auto
  #     span[class="badge badge-pill #{shards_state_helper(unit.state)}"]= t(unit.state, scope:'views.common').upcase
  # / td.lo-stats__items.text-center 12
  # - unless unit.bought? or unit.booked?
  #   td.lo-stats__total.text-center.text-info= number_with_precision unit.value
  # - else
  #   td.lo-stats__total.text-center.text-danger.text-uppercase= t(:bought, scope:'views.common')


  def badge_link_helper(build)
    if build.units_sales?
      klass = 'card-post__category badge badge-pill badge-info'
      title = I18n.t(:available, scope: 'views.dashboards')
    else
      klass = 'card-post__category badge badge-pill badge-warning'
      title = I18n.t(:unavailable, scope: 'views.dashboards')
    end
    content_tag :a, title, href: new_public_build_proposal_path(build), class: klass
  end

  def shards_state_helper(state)
      case state
      when 'pending'
        'badge-info'
      when 'booked'
        'badge-secondary'
      when 'bought'
        'badge-salmon'
      end
  end
  
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