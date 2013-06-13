require "mongoid-sequence/version"
require "active_support/concern"

module Mongoid
  module Sequence
    extend ActiveSupport::Concern

    included do
      set_callback :validate, :before, :set_sequence, :unless => :persisted?
    end

    module ClassMethods
      attr_accessor :sequence_fields

      def sequence(field, options = {})
        self.sequence_fields ||= []
        self.sequence_fields << [field, options]
      end
    end

    def set_sequence
      self.class.sequence_fields.each do |field, options|
        offset        = options[:offset]
        next_sequence = self.class.collection.
                        database.session.command(findAndModify: "__sequences",
                                                 query:  {"_id" => "#{self.class.name.underscore}_#{field}"},
                                                 update: {"$inc" => {"seq" => 1}},
                                                 new:    true,
                                                 upsert: true)

        self[field] = next_sequence["value"]["seq"]
        self[field] += offset - 1 if offset
      end if self.class.sequence_fields
    end
  end
end
