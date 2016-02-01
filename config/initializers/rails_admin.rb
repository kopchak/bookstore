RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan
  config.authenticate_with do
    warden.authenticate! scope: :customer
  end
  #config.current_user_method(&:current_customer)
  config.current_user_method(&:current_customer)


  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  
  config.included_models = ["Book", "Author", "Category", "Rating", "Order", "Discount"]

  config.model 'Book' do
    list do
      exclude_fields :image
    end
    edit do
      include_fields :title, :price, :author, :category, :stock_qty, :description, :image
    end
  end

  config.model 'Author' do
    edit do
      include_fields :firstname, :lastname, :biography
    end
  end

  config.model 'Category' do
    edit do
      include_fields :title
    end
  end

  config.model 'Rating' do
    edit do
      include_fields :check
    end
  end

  config.model 'Order' do
    edit do
      include_fields :state
    end
  end

  config.model 'Discount' do
    edit do
      include_fields :amount
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
