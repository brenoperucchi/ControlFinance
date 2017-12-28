# class PagesRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput

#   # Creates a radio button set for use with Semantic UI

#   def input(wrapper_options)
#     label_method, value_method = detect_collection_methods
#     merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
#     # iopts = { 
#     #   :checked => 1,
#     #   :item_wrapper_tag => 'div',
#     #   :item_wrapper_class => 'radio radio-primary',
#     #   :collection_wrapper_tag => 'div',
#     #   :collection_wrapper_class => 'radio radio-primary'
#     #  }
#     tag = String.new
#     tag << "<div class='radio radio-primary'>".html_safe
#     tag << "#{@builder.text_field(:option1, merged_input_options)}".html_safe
#     tag << @builder.label(:option1, merged_input_options)
#     tag << @builder.text_field(:option2, merged_input_options).html_safe
#     tag << @builder.label(:option2, merged_input_options)
#     tag << "</div>".html_safe
#     return tag.html_safe
#     # return tag.html_safe
#     # @builder.send("collection_radio_buttons", attribute_name, collection, value_method, label_method, iopts, input_html_options, &collection_block_for_nested_boolean_style )

# # .radio.radio-primary
# #   input name="[broker]option1" type="radio" checked="checked" value="0" id='choice1'
# #   label for="choice1"
# #     = t(:not_accept)
# #   input name="[broker]option1" type="radio" value="1" id='choice2'
# #   label for="choice2"
# #     = t(:accept)



#   end # method

#   def generate_label_for_attribute?
#     false
#   end

#   protected

#   def build_nested_boolean_style_item_tag(collection_builder)
#     tag = String.new
#     # tag << '<div class="ui radio checkbox">'.html_safe
#     tag << collection_builder.radio_button + collection_builder.label
#     # tag << '</div>'.html_safe
#     return tag.html_safe
#   end # method

# end # class