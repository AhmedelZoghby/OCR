if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
    schedule = {}

    for day in range(7):
        day_name = days[day]
        schedule[day_name] = {}

        for shift in range(2):
            shift_name = shift_names[shift]
            devs_in_shift = []
            projects_in_shift = []

            for d in developers:
                if solver.Value(work[(d, day, shift)]) == 1:
                    for p in projects:
                        if (d, day, shift, p) in assign and solver.Value(assign[(d, day, shift, p)]) == 1:
                            devs_in_shift.append(d)
                            projects_in_shift.append(p)
                            break

            schedule[day_name][shift_name] = {
                "Devs": devs_in_shift,
                "Projects": projects_in_shift
            }

    print(json.dumps({"solver_status": solver.StatusName(status)}))
    print()
    print(json.dumps({"minimum_cost": str(solver.Value(minimum_cost))}))
    print()
    print(json.dumps({"schedule": schedule}, indent=2))

else:
    empty_schedule = {
        day_name: {
            "Morning": {"Devs": [], "Projects": []},
            "Evening": {"Devs": [], "Projects": []}
        }
        for day_name in days
    }

    print(json.dumps({"solver_status": solver.StatusName(status)}))
    print()
    print(json.dumps({"minimum_cost": "No feasible solution found"}))
    print()
    print(json.dumps({"schedule": empty_schedule}, indent=2))
``
