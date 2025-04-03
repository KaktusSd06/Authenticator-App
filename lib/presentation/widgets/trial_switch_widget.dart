import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/trial/trial_bloc.dart';
import '../../logic/blocs/trial/trial_event.dart';
import '../../logic/blocs/trial/trial_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TrialSwitchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrialBloc(),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<TrialBloc, TrialState>(
            builder: (context, state) {
              bool isTrialEnabled = false;

              if (state is TrialInitialState) {
                isTrialEnabled = state.isTrialEnabled;
              }
              if (state is TrialStateUpdated) {
                isTrialEnabled = state.isTrialEnabled;
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: isTrialEnabled ? Color(0xFF094086) : Colors.grey,
                    width: 3,
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(right: 6, left: 24, top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.free_Trial_Enabled ?? '',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Color(0xFF2A313E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Switch(
                      value: isTrialEnabled,
                      onChanged: (value) {
                        // Dispatch event to toggle the trial
                        BlocProvider.of<TrialBloc>(context).add(ToggleTrialEvent());
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Color(0xFF00CF00),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Color(0xFFD9D9D9),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
