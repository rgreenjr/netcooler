class CompanySweeper < ActionController::Caching::Sweeper

  observe Company

  def after_save(company)
    expire_cache(company)
  end

  def after_destroy(company)
    expire_cache(company)
  end

  def expire_cache(company)
    expire_fragment('sidebar_companies')
  end

end