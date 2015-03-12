module ModelHelper
  def self.to_hash(record)
    r = {}
    record.attributes.each do |k,v|
      r[k] = v
    end

    r['check_point_id'] = CheckPoint.find(r['check_point_id']).name if r['check_point_id']
    r['area_id'] = Area.find(r['area_id']).name if r['area_id']
    r['result_image_id'] = ResultImage.find(r['result_image_id']).name if r['result_image_id']
    r['created_by_id'] = User.find(r['created_by_id']).name if r['created_by_id']
    r['assigned_to_id'] = User.find(r['assigned_to_id']).name if r['assigned_to_id']
    r
  end
end