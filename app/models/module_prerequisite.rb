class ModulePrerequisite < ApplicationRecord
  belongs_to :curriculum_module, class_name: "CurriculumModule"
  belongs_to :prerequisite_module, class_name: "CurriculumModule"
end
