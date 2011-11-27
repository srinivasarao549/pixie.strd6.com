#= require underscore
#= require backbone
#= require views/paginated
#= require views/sprites/sprite
#= require models/sprites_collection
#= require models/paginated_collection

#= require tmpls/sprites/header
#= require tmpls/pagination

window.Pixie ||= {}
Pixie.Views ||= {}
Pixie.Views.Sprites ||= {}

class Pixie.Views.Sprites.Gallery extends Pixie.Views.Paginated
  events:
    'click .tag': 'searchTags'
    'click .reset': 'resetSearch'

  initialize: ->
    self = @

    @el = ".sprites"

    # merge the superclass paging related events
    @events = _.extend(@pageEvents, @events)
    @delegateEvents()

    @collection = new Pixie.Models.SpritesCollection

    @collection.bind 'fetching', ->
      $(self.el).find('.spinner').show()

    @collection.bind 'reset', (collection) ->
      $(self.el).find('.header').remove()
      $(self.el).find('.pagination').remove()
      $(self.el).append $.tmpl("sprites/header", self.collection.pageInfo())
      $(self.el).find('.header h2').after $('<button class="reset complement">Reset Tags</button>')
      $(self.el).find('.reset').show() if self.collection.params.tagged

      $(self.el).find('.sprite_container').remove()
      $(self.el).find('.spinner').hide()
      collection.each(self.addSprite)

      self.updatePagination()
      self.updateTags(collection)

  addSprite: (sprite) =>
    view = new Pixie.Views.Sprites.Sprite({ model: sprite })
    $(@el).append(view.render().el)

  resetSearch: =>
    @collection.resetSearch()
    $(@el).find('.reset').hide()

  searchTags: (e) =>
    $(@el).find('.reset').show()
    tag = $(e.target).text().toLowerCase()
    @collection.filterTagged(tag)

  updatePagination: =>
    $(@el).find('.pagination').html $.tmpl('pagination', @collection.pageInfo())

  updateTags: (collection) =>
    tags = []

    $('.tags').empty()

    for model in collection.models
      for tag in model.attributes.tags
        tags.push tag.name unless $.inArray(tag.name, tags) >= 0

    for name in tags
      $('.tags').append($("<div class='tag'><a href='#'>#{name}</a></div>"))

