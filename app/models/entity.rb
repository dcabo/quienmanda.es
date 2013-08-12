class Entity < ActiveRecord::Base
  extend Enumerize
  enumerize :priority, in: {:high => 1, :medium => 2, :low => 3}

  mount_uploader :avatar, AvatarUploader

  has_many :relations_as_source, foreign_key: :source_id, class_name: Relation, inverse_of: :source
  has_many :relations_as_target, foreign_key: :target_id, class_name: Relation, inverse_of: :target

  acts_as_url :short_or_long_name, url_attribute: :slug, only_when_blank: true, sync_url:  true
  def to_param
    slug
  end

  validates :name, presence: true, uniqueness: true
  validates :priority, presence: true
  validates :description, length: { maximum: 90 }

  scope :published, -> { where(published: true) }
  scope :people, -> { where(person: true) }
  scope :organizations, -> { where(person: false) }

  # Returns the short name if present, the long one otherwise
  def short_or_long_name
    (short_name.nil? || short_name.blank?) ? name : short_name
  end

  # Returns all the relations an entity is involved in.
  #   This is cleaner than prefetching relations_as_source, adding to relations_as_source...
  def relations
    Relation.where('source_id = ? or target_id = ?', self, self)
  end

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :needs_work
      field :priority
      field :person
      field :name
      field :short_name
      field :description
    end

    edit do
      group :basic_info do
        label "Basic info"
        field :person do
          default_value true
        end
        field :name
        field :short_name
        field :description
        field :priority do
          default_value :medium
        end
        field :avatar
      end
      group :social_media do
        label "Social media"
        field :twitter_handle
        field :wikipedia_page
        field :facebook_page
        field :flickr_page
        field :linkedin_page
      end
      group :relations do
        # Editing the relations through the default RailsAdmin control (moving across
        # two columns) is very confusing. So disable for now.
        field :relations_as_source do
          read_only true
          inverse_of :source
        end
        field :relations_as_target do
          read_only true
          inverse_of :target
        end
      end
      group :internal do
        label "Internal"
        field :published do
          default_value false
        end
        field :needs_work do
          default_value true
        end
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :notes
      end
    end

    object_label_method do
      :short_or_long_name
    end
  end
end
