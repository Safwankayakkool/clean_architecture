import 'package:clean_architecture/features/authentication/presentation/cubic/authentication_cubit.dart';
import 'package:clean_architecture/features/authentication/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUsers() {
    context.read<AuthenticationCubit>().getUser();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsers
              ? const LoadingWidget(message: 'Fetching users')
              : state is CreatingUser
                  ? const LoadingWidget(message: 'Creating users')
                  : state is UsersLoaded
                      ? Center(
                          child: ListView.builder(
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                return Text('data $user');
                              }),
                        )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<AuthenticationCubit>().createUser(
                  name: "John", createdAt: DateTime.now().toIso8601String());
            },
            isExtended: true,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
