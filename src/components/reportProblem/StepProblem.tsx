import Field, { TextInput, TextArea, SelectInput } from '../form/Field';
import { CATEGORIES, type ProblemFormData, type FormErrors } from '../../reportProblemTypes';

interface StepProblemProps {
  data: ProblemFormData;
  errors: FormErrors;
  update: (field: keyof ProblemFormData, value: string) => void;
}

export default function StepProblem({ data, errors, update }: StepProblemProps) {
  const subcategories = data.category ? CATEGORIES[data.category] ?? [] : [];

  return (
    <div className="space-y-5">
      <Field label="Problem title" required error={errors.title} htmlFor="title">
        <TextInput
          id="title"
          value={data.title}
          onChange={(v) => update('title', v)}
          placeholder="e.g. Potholes on Main Street causing accidents"
          hasError={!!errors.title}
        />
      </Field>

      <Field
        label="Detailed description"
        required
        error={errors.description}
        htmlFor="description"
      >
        <TextArea
          id="description"
          value={data.description}
          onChange={(v) => update('description', v)}
          placeholder="Describe the problem in detail. What is happening, when did it start, and why does it matter?"
          hasError={!!errors.description}
          rows={5}
        />
      </Field>

      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
        <Field
          label="Problem category"
          required
          error={errors.category}
          htmlFor="category"
        >
          <SelectInput
            id="category"
            value={data.category}
            onChange={(v) => {
              update('category', v);
              update('subcategory', '');
            }}
            placeholder="Select a category"
            hasError={!!errors.category}
          >
            {Object.keys(CATEGORIES).map((cat) => (
              <option key={cat} value={cat}>
                {cat}
              </option>
            ))}
          </SelectInput>
        </Field>

        <Field
          label="Subcategory"
          required
          error={errors.subcategory}
          htmlFor="subcategory"
        >
          <SelectInput
            id="subcategory"
            value={data.subcategory}
            onChange={(v) => update('subcategory', v)}
            placeholder={data.category ? 'Select a subcategory' : 'Select a category first'}
            hasError={!!errors.subcategory}
          >
            {subcategories.map((sub) => (
              <option key={sub} value={sub}>
                {sub}
              </option>
            ))}
          </SelectInput>
        </Field>
      </div>
    </div>
  );
}
