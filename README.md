# Fleet Ops Live

https://github.com/teddiguna0001/route-link-fleet

FEATURE 3 — CREW MANAGEMENT

========================================================

Implement fully functional crew management.

Support:

- Add Crew

- Edit Crew

- View Crew

- Assign Crew

- Change Status

- Deactivate

- Reactivate

Crew fields should include:

- crew ID

- name

- role

- depot

- shift

- status

- availability

Crew status should support:

AVAILABLE

ASSIGNED

OFF_DUTY

UNAVAILABLE

INACTIVE

Only eligible crew can be assigned to new trips.

========================================================

FEATURE 4 — BUS DAY TIMELAPSE

========================================================

Implement a REAL 24-hour operational simulation.

This is NOT simply an animation.

Create a simulation clock representing the operational day.

Example:

06:00 → 22:00

The simulation must derive bus positions from:

- assigned route

- route geometry

- trip start time

- trip end time

- current simulation time

When simulation time changes, bus positions on the map must update accordingly.

Example:

Trip:

08:00–09:00

At:

08:15 → bus should be approximately 25% through the trip route.

08:30 → approximately 50%.

08:45 → approximately 75%.

09:00 → trip completed.

Use interpolation along the existing route geometry.

DO NOT use real GPS.

DO NOT claim live location.

Label this clearly as:

"Operational Simulation"

or

"24-Hour Simulation"

Controls required:

- Play

- Pause

- Reset

- Timeline slider

- Current simulation time

- Speed control

Suggested speed options:

1×

5×

10×

30×

The simulation should move buses on the EXISTING map.

========================================================

FEATURE 5 — DAILY OPERATIONS TIMELINE

========================================================

Create a timeline showing what is happening during the simulated day.

This must be generated from actual simulation data.

Examples of events:

- service start

- bus departure

- trip completion

- bus becoming available

- crew assignment

- peak period

- disruption

- recovery

- maintenance event

- depot return

DO NOT hardcode a fake list of events.

The timeline should react to the simulation clock.

For example:

08:15

Route 522 disruption

08:16

3 trips affected

08:17

Replacement assignment initiated

08:20

Recovery completed

These events should come from the system's actual state.

dont change ui of application

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/c47f9daa-a7a1-446e-8696-77915890405f).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
