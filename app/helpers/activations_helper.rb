module ActivationsHelper
  def invite_link(text,thing)
    attrs =  {
      :href => '#',
      :class => 'invite-link',
      'data-target-class' => thing.class.to_s,
      'data-target-id' => thing.id,
    }
    haml_tag :a, text, attrs
  end
end
