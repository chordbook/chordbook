class Section
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :scope
  attribute :scopes, array: true
  attribute :limit, :integer, default: 12
  attribute :format, :string, default: "item"
  attribute :href, :string

  def items
    @items ||= if scope
      scope.limit(limit)
    else
      scopes.reduce([]) do |items, scope|
        items + scope.where.not(id: items).limit(limit - items.length).to_a
      end
    end
  end
end
