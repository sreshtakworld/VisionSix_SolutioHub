import Field, { TextInput } from '../form/Field';
import type { ProblemFormData, FormErrors } from '../../reportProblemTypes';

interface StepLocationProps {
  data: ProblemFormData;
  errors: FormErrors;
  update: (field: keyof ProblemFormData, value: string) => void;
}

export default function StepLocation({ data, errors, update }: StepLocationProps) {
  return (
    <div className="space-y-5">
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
        <Field label="City" required error={errors.city} htmlFor="city">
          <TextInput
            id="city"
            value={data.city}
            onChange={(v) => update('city', v)}
            placeholder="e.g. Springfield"
            hasError={!!errors.city}
          />
        </Field>

        <Field label="State" required error={errors.state} htmlFor="state">
          <TextInput
            id="state"
            value={data.state}
            onChange={(v) => update('state', v)}
            placeholder="e.g. Illinois"
            hasError={!!errors.state}
          />
        </Field>
      </div>

      <Field
        label="Area / locality"
        required
        error={errors.area}
        htmlFor="area"
      >
        <TextInput
          id="area"
          value={data.area}
          onChange={(v) => update('area', v)}
          placeholder="e.g. Downtown, North Side, Riverside"
          hasError={!!errors.area}
        />
      </Field>

      <Field
        label="Approximate number of people affected"
        required
        error={errors.peopleAffected}
        htmlFor="peopleAffected"
      >
        <TextInput
          id="peopleAffected"
          type="number"
          value={data.peopleAffected}
          onChange={(v) => update('peopleAffected', v)}
          placeholder="e.g. 500"
          hasError={!!errors.peopleAffected}
        />
      </Field>
    </div>
  );
}
