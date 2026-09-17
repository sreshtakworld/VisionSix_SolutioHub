import Field, { TextInput, SelectInput } from '../form/Field';
import {
  SEVERITY_OPTIONS,
  SEVERITY_STYLES,
  FREQUENCY_OPTIONS,
  type ProblemFormData,
  type FormErrors,
  type Severity,
} from '../../reportProblemTypes';

interface StepUrgencyProps {
  data: ProblemFormData;
  errors: FormErrors;
  update: (field: keyof ProblemFormData, value: string) => void;
}

export default function StepUrgency({ data, errors, update }: StepUrgencyProps) {
  return (
    <div className="space-y-5">
      <Field
        label="Severity"
        required
        error={errors.severity}
      >
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          {SEVERITY_OPTIONS.map((level) => {
            const isSelected = data.severity === level;
            return (
              <button
                key={level}
                type="button"
                onClick={() => update('severity', level)}
                className={`rounded-xl border-2 px-4 py-3 text-sm font-semibold transition-all ${
                  isSelected
                    ? `${SEVERITY_STYLES[level]} ring-2 ring-offset-1 ring-current scale-[1.02]`
                    : 'border-ink-200 bg-white text-ink-600 hover:border-ink-300 hover:bg-ink-50'
                }`}
              >
                {level}
              </button>
            );
          })}
        </div>
      </Field>

      <Field
        label="How frequently does this problem occur?"
        required
        error={errors.frequency}
        htmlFor="frequency"
      >
        <SelectInput
          id="frequency"
          value={data.frequency}
          onChange={(v) => update('frequency', v)}
          placeholder="Select frequency"
          hasError={!!errors.frequency}
        >
          {FREQUENCY_OPTIONS.map((freq) => (
            <option key={freq} value={freq}>
              {freq}
            </option>
          ))}
        </SelectInput>
      </Field>

      <Field
        label="Who is mainly affected?"
        required
        error={errors.affectedGroup}
        htmlFor="affectedGroup"
      >
        <TextInput
          id="affectedGroup"
          value={data.affectedGroup}
          onChange={(v) => update('affectedGroup', v)}
          placeholder="e.g. School children, elderly residents, daily commuters"
          hasError={!!errors.affectedGroup}
        />
      </Field>
    </div>
  );
}
