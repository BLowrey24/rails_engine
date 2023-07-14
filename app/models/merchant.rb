class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.merchant_search(keyword)
    Merchant.where('name ILIKE ?', "%#{keyword}%").order(:name).first
  end
end