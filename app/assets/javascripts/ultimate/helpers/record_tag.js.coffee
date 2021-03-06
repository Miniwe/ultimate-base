#= require ./base
#= require ./tag

@Ultimate.Helpers.RecordTag =

  div_for: (record, args...) ->
    @content_tag_for "div", record, args...

  content_tag_for: (tag_name, single_or_multiple_records, prefix = null, options = null, block = null) ->
    block = _.outcasts.blockGiven(arguments)
    if _.isFunction(single_or_multiple_records.map)
      single_or_multiple_records.map( (single_record) =>
        @content_tag_for_single_record(tag_name, single_record, prefix, options, block)
      ).join("\n")
    else
      @content_tag_for_single_record(tag_name, single_or_multiple_records, prefix, options, block)

  content_tag_for_single_record: (tag_name, record, prefix, options, block = null) ->
    [options, prefix] = [prefix, null]  if _.isObject(prefix)
    block = _.outcasts.blockGiven(arguments)
    options = if  _.isObject(options) then _.clone(options) else {}
    _.extend options, {class: Ultimate.Helpers.Tag.concat_class(@dom_class(record, prefix), options['class']), id: @dom_id(record, prefix)}
    if block
      Ultimate.Helpers.Tag.content_tag(tag_name, block(record), options)
    else
      Ultimate.Helpers.Tag.content_tag(tag_name, block, options)

  # ============= from ActionController::RecordIdentifier ===============

  # The DOM class convention is to use the singular form of an object or class. Examples:
  #
  #   dom_class(post)   # => "post"
  #   dom_class(Person) # => "person"
  #
  # If you need to address multiple instances of the same class in the same view, you can prefix the dom_class:
  #
  #   dom_class(post, :edit)   # => "edit_post"
  #   dom_class(Person, :edit) # => "edit_person"
  dom_class: (record_or_class, prefix = "") ->
    # TODO improve as in Ultimate.Backbone.Model
    if _.isString(record_or_class)
      singular = _.singularize(record_or_class)
    else unless singular = _.result(record_or_class, 'singular')
      if _.isString(record_or_class?.constructor?.name)
        singular = _.singularize(_.string.underscored(record_or_class.constructor.name))
    if prefix then "#{prefix}_#{singular}" else singular

  # The DOM id convention is to use the singular form of an object or class with the id following an underscore.
  # If no id is found, prefix with "new_" instead. Examples:
  #
  #   dom_id(Post.find(45))       # => "post_45"
  #   dom_id(new Post)            # => "new_post"
  #
  # If you need to address multiple instances of the same class in the same view, you can prefix the dom_id:
  #
  #   dom_id(Post.find(45), "edit") # => "edit_post_45"
  # TODO sync with rorId and ror_id
  dom_id: (record, prefix = "") ->
    if record_id = @sanitize_dom_id(record.id)
      "#{@dom_class(record, prefix)}_#{record_id}"
    else
      @dom_class(record, prefix or "new")

  # Replaces characters that are invalid in HTML DOM ids with valid ones.
  sanitize_dom_id: (candidate_id) ->
    candidate_id # TODO implement conversion to valid DOM id values
