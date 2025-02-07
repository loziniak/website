class Markdown::Parse
  include Mandate

  # TODO: This needs fixing in mandate but I don't know
  # how to do it without breaking hashes passed as the
  # last argument
  def self.call(*args, **kwargs)
    new(*args, **kwargs).()
  end

  def initialize(text, nofollow_links: false, strip_h1: true, lower_heading_levels_by: 1)
    @text = text
    @nofollow_links = nofollow_links
    @strip_h1 = strip_h1
    @lower_heading_levels_by = lower_heading_levels_by
  end

  def call
    return "" if text.blank?

    sanitized_html
  end

  private
  attr_reader :text, :nofollow_links, :strip_h1, :lower_heading_levels_by

  memoize
  def sanitized_html
    remove_comments = Loofah::Scrubber.new do |node|
      node.remove if node.name == "comment"
    end

    Loofah.fragment(raw_html).scrub!(remove_comments).scrub!(:escape).to_s
  end

  memoize
  def raw_html
    doc = Markdown::Render.(text, :doc, strip_h1: strip_h1, lower_heading_levels_by: lower_heading_levels_by)
    Markdown::RenderHTML.(doc, nofollow_links)
  end
end
