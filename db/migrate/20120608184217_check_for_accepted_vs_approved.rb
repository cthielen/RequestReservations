class CheckForAcceptedVsApproved < ActiveRecord::Migration
  def up
    s = Status.find_by_label('Accepted')
    if s
      s.label = 'Approved'
      s.save
    end
  end

  def down
    s = Status.find_by_label('Approved')
    if s
      s.label = 'Accepted'
      s.save
    end
  end
end
