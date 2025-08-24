import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ndk/entities.dart';
import 'package:nip19/nip19.dart';
import 'package:couleur/repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:couleur/l10n/app_localizations.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final messages = Repository.to.rooms[Repository.to.selectedRoom.value]!;

      // Scroll to bottom when messages change
      _scrollToBottom();

      return ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageView(message: messages[index]);
        },
      );
    });
  }
}

class MessageView extends StatelessWidget {
  final Nip01Event message;

  const MessageView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Check if message contains a Cashu token
    final hasCashuToken =
        message.content.contains('cashuA') ||
        message.content.contains('cashuB');

    // Check if message contains a Lightning invoice
    final hasLightningInvoice =
        message.content.contains('lnbc') ||
        message.content.contains('lntb') ||
        message.content.contains('lnbcrt');

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  items: [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 20),
                          SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)?.viewProfile ??
                                'View Profile',
                          ),
                        ],
                      ),
                      onTap: () async {
                        final url = Uri.parse(
                          'https://njump.me/${Nip19.npubFromHex(message.pubKey)}',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.alternate_email, size: 20),
                          SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)?.mention ?? 'Mention',
                          ),
                        ],
                      ),
                      onTap: () {
                        final currentText =
                            Repository.to.sendFieldController.text;
                        final mention =
                            '@${Repository.to.names[message.pubKey]} ';
                        Repository.to.sendFieldController.text =
                            currentText + mention;
                        Repository
                            .to
                            .sendFieldController
                            .selection = TextSelection.fromPosition(
                          TextPosition(
                            offset:
                                Repository.to.sendFieldController.text.length,
                          ),
                        );
                        Repository.to.sendFieldFocusNode.requestFocus();
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.volume_off, size: 20),
                          SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)?.muteUser ??
                                'Mute User',
                          ),
                        ],
                      ),
                      onTap: () {
                        Repository.to.muteUser(message.pubKey);
                      },
                    ),
                  ],
                );
              },
              child: Text(
                Repository.to.names[message.pubKey]!,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          FutureBuilder(
            future: Repository.ndk.metadata.loadMetadata(message.pubKey),
            builder: (context, snapshot) {
              if (snapshot.data == null) return Container();
              final metadata = snapshot.data!;

              if (metadata.nip05 == null) return Container();

              return FutureBuilder(
                future: Repository.ndk.nip05.check(
                  nip05: metadata.nip05!,
                  pubkey: metadata.pubKey,
                ),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return Container();
                  if (snapshot.data!.valid) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.verified,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    );
                  }
                  return Container();
                },
              );
            },
          ),
        ],
      ),
      subtitle: (hasCashuToken || hasLightningInvoice)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.content
                    .replaceAll(RegExp(r'cashu[AB][a-zA-Z0-9_\-=]+'), '')
                    .replaceAll(RegExp(r'ln(bc|tb|bcrt)[0-9a-z]+'), '')
                    .trim()
                    .isNotEmpty)
                  SelectableText(
                    // Remove both Cashu tokens and Lightning invoices from the displayed message
                    message.content
                        .replaceAll(RegExp(r'cashu[AB][a-zA-Z0-9_\-=]+'), '')
                        .replaceAll(RegExp(r'ln(bc|tb|bcrt)[0-9a-z]+'), '')
                        .trim(),
                  ),
                if (message.content
                    .replaceAll(RegExp(r'cashu[AB][a-zA-Z0-9_\-=]+'), '')
                    .replaceAll(RegExp(r'ln(bc|tb|bcrt)[0-9a-z]+'), '')
                    .trim()
                    .isNotEmpty)
                  SizedBox(height: 8),
                if (hasCashuToken) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/mstile-150x150.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)?.cashuToken ??
                              'Cashu Token',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            final tokenMatch = RegExp(
                              r'(cashu[AB][a-zA-Z0-9_\-=]+)',
                            ).firstMatch(message.content);
                            if (tokenMatch != null) {
                              final token = tokenMatch.group(0)!;
                              Clipboard.setData(ClipboardData(text: token));
                            }
                          },
                          icon: Icon(Icons.copy, size: 16),
                        ),
                      ],
                    ),
                  ),
                  if (hasLightningInvoice) SizedBox(height: 8),
                ],
                if (hasLightningInvoice)
                  Builder(
                    builder: (context) {
                      // Extract the invoice and parse amount
                      final invoiceMatch = RegExp(
                        r'ln(bc|tb|bcrt)([0-9]+)([munp]?)([0-9a-z]+)',
                      ).firstMatch(message.content);

                      String amountText = '';
                      if (invoiceMatch != null) {
                        final amountStr = invoiceMatch.group(2) ?? '';
                        final multiplier = invoiceMatch.group(3) ?? '';

                        if (amountStr.isNotEmpty) {
                          try {
                            int amount = int.parse(amountStr);
                            // Convert to sats based on multiplier
                            switch (multiplier) {
                              case 'm': // milli-bitcoin (0.001 BTC)
                                amount = amount * 100000;
                                break;
                              case 'u': // micro-bitcoin (0.000001 BTC)
                                amount = amount * 100;
                                break;
                              case 'n': // nano-bitcoin (0.000000001 BTC)
                                amount = amount ~/ 10;
                                break;
                              case 'p': // pico-bitcoin (0.000000000001 BTC)
                                amount = amount ~/ 10000;
                                break;
                              default: // no multiplier means the amount is in BTC * 10^11
                                amount = amount * 10;
                            }
                            amountText = ' • ${amount.toString()} sats';
                          } catch (e) {
                            // If parsing fails, don't show amount
                          }
                        }
                      }

                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              amountText.isNotEmpty
                                  ? (AppLocalizations.of(
                                          context,
                                        )?.lightningInvoiceWithAmount(
                                          amountText
                                              .replaceAll(': ', '')
                                              .replaceAll(' sats', ''),
                                        ) ??
                                        'Lightning Invoice$amountText')
                                  : (AppLocalizations.of(
                                          context,
                                        )?.lightningInvoice ??
                                        'Lightning Invoice'),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                final invoiceMatch = RegExp(
                                  r'(ln(bc|tb|bcrt)[0-9a-z]+)',
                                ).firstMatch(message.content);
                                if (invoiceMatch != null) {
                                  final invoice = invoiceMatch.group(0)!;
                                  Clipboard.setData(
                                    ClipboardData(text: invoice),
                                  );
                                }
                              },
                              icon: Icon(Icons.copy, size: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            )
          : SelectableText(message.content),
    );
  }
}
