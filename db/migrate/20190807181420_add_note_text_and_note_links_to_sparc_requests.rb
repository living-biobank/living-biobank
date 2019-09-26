class AddNoteTextAndNoteLinksToSparcRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :note_text, :longtext, after: :protocol_id
    add_column :sparc_requests, :note_links, :longtext, after: :note_text
  end
end
