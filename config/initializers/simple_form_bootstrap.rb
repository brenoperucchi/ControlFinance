# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn'
  config.boolean_label_class = nil

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'control-label'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'control-label'

    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group row', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'div', class: 'col-md-8' do |ba| 
      ba.use :label, class: 'control-label'
    end
    b.wrapper tag: 'div', class: 'col-md-4' do |ba|
      ba.use :input
    end
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'col-sm-offset-3 col-sm-9' do |wr|
      wr.wrapper tag: 'div', class: 'checkbox' do |ba|
        ba.use :label_input
      end

      wr.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      wr.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :multi_select, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'control-label'
    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end
  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :vertical_file_input,
    boolean: :vertical_boolean,
    datetime: :multi_select,
    date: :multi_select,
    time: :multi_select
  }


  config.wrappers :vertical_input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'

    b.wrapper tag: 'div' do |ba|
      ba.wrapper tag: 'div', class: 'input-group col-sm-12' do |append|
        append.use :input, class: 'form-control'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end


  config.wrappers :pages_form, tag: 'div', class: 'row clearfix', error_class: 'has-error' do |b|
    b.wrapper tag: 'div', class: 'col-md-12' do |ba|
      ba.wrapper tag: 'div', class: 'form-group form-group-default' do |bb|
        # ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
        bb.use :label, class: ''
        bb.use :html5
        bb.use :placeholder
        bb.use :input, class: 'form-control input-sm'
        # ba.wrapper tag: 'div', class: 'form-group form-group-default' do |append|
           
        # end
      end
      ba.use :error, wrap_with: { tag: 'label', class: 'error' }
    end
  end

  config.wrappers :pages_form_default, tag: 'div', class: 'row', error_class: 'has-error' do |b|
    b.wrapper tag: 'div', class: 'form-group form-group-default' do |bb|
      bb.use :label, class: ''
      bb.use :html5
      bb.use :placeholder
      bb.use :input, class: 'form-control'
    end
    b.use :error, wrap_with: { tag: 'label', class: 'error' }
  end

  config.wrappers :pages_form_attach, tag: 'div', class: 'row', error_class: 'has-error' do |b|
    b.wrapper tag: 'div', class: 'form-group form-group-default input-group' do |bb|
      bb.wrapper tag: 'div', class: 'form-input-group' do |bc|
        bc.use :label, class: ''
        bc.use :html5
        bc.use :placeholder
        bc.use :input, class: 'form-control'
      end
      bb.wrapper tag: 'div', class: 'input-group-addon d-flex' do |bb|
        bb.use :hint
      end
    end
    b.use :error, wrap_with: { tag: 'label', class: 'error' }
  end

  config.wrappers :pages_vertical_radio, error_class: 'has-error' do |b|
    b.wrapper tag: 'div', class: 'form-group row' do |bf|
      bf.use :html5
      bf.optional :readonly
      bf.use :label, class: 'control-label col-md-8'
      bf.wrapper tag: 'div', class: 'col-md-4' do |ba| 
        ba.use :input
      end
      bf.use :error, wrap_with: { tag: 'label', class: 'error' }
      bf.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :append, :tag => 'div', :class => "form-group", :error_class => 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    # b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |input|
      # input.wrapper :tag => 'div', :class => 'input-append' do |append|
      input.use :input
      input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
      input.use :error, wrap_with: { tag: 'label', class: 'error' }
    end
  end

end