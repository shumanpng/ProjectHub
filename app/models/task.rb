class Task < ActiveRecord::Base

  ## Reference: http://filterrific.clearcove.ca/pages/active_record_model_api.html ##
  # This directive enables Filterrific for the Task class.
  # We define a default sorting by most recent task creation, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_state,
      :with_created_at_gte
    ]
  )

  # belongs_to :group
  belongs_to :user

  ## V A L I D A T I O N S ##
  # validates_length_of :title, :minimum => 1
  validates :title, :presence => true
  validates :created_by, :presence => true
  validates :state, :presence => true

  ## S C O P E S ##
  ## Reference: http://filterrific.clearcove.ca/pages/active_record_scope_patterns.html"
  scope :search_query, lambda { |query|
    # Filters students whose name or email matches the query
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }

    num_or_conds = 2
    where(
      terms.map { |term|
        "(LOWER(task.title) LIKE ? OR LOWER(task.created_by) LIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )



  }
  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title/
      order("LOWER(tasks.title) #{ direction }")
    when /^created_by/
      order("LOWER(tasks.created_by) #{ direction }")
    # when /^created_at/
    #   order("LOWER(tasks.created_at) #{ direction }")
    else
      # raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end

  }
  # filters on Task state attribute
  scope :with_state, lambda { |states|
    where(state: [*states])

  }
  scope :with_created_at_gte, lambda { |ref_date|

  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ['Task title (a-z)', 'title_asc'],
      ['Task title (z-a)', 'title_desc'],
      ['Created by (a-z)', 'created_by_asc'],
      ['Created by (z-a)', 'created_by_desc']
      # ['Dated created (newest first)', 'created_at_desc'],
      # ['Date created (oldest first)', 'created_at_asc'],
      # ['Created_by (a-z)', 'country_name_asc']
    ]
  end

  # app/models/country.rb
  def self.options_for_select
    order('LOWER(state)').map { |e| [e.state] }
  end

end
