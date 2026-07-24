class Province < ApplicationRecord
  has_many :orders

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  def total_tax_rate
    gst + pst + hst
  end

  def tax_description
    parts = []
    parts << "GST #{(gst * 100).round(1)}%" if gst > 0
    parts << "PST #{(pst * 100).round(1)}%" if pst > 0
    parts << "HST #{(hst * 100).round(1)}%" if hst > 0
    parts.join(" + ")
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "code", "gst", "pst", "hst", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end
end